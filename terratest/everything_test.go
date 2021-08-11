package test

import (
	"errors"
	"testing"
	// "time"

	// http_helper "github.com/gruntwork-io/terratest/modules/http-helper"

	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
	"github.com/gruntwork-io/terratest/modules/aws"
)

func TestTerraformHelloWorldExample(t *testing.T) {
	expectedAccount := "029718257588"

	err := checkAccount(t, expectedAccount)

	if err != nil {
		t.Fatal(err)
	}

	terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
		TerraformDir: "../",
	})

	defer terraform.Destroy(t, terraformOptions)

	terraform.InitAndApply(t, terraformOptions)

	instanceId := terraform.Output(t, terraformOptions, "instance_id")

	tags := aws.GetTagsForEc2Instance(t, "", instanceId)

	// http_helper.HttpGetWithRetry(t, "http://google.com", nil, 200, "Hello, World!", 60, 5*time.Second)

	// output := terraform.Output(t, terraformOptions, "hello_world")
	nameTag, nameTagExists := tags["Name"]
	assert.True(t, nameTagExists)
	assert.Equal(t, nameTag, "testing-terraform-test-frameworks")
}


func checkAccount(t *testing.T, expectedAccount string) error {
	accountId := aws.GetAccountId(t)

	if accountId != expectedAccount {
		return errors.New("Expected to be running in " + expectedAccount + ", but running in: " + accountId)
	}

	return nil
}