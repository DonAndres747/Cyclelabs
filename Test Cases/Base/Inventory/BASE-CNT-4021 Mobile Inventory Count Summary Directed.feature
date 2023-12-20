############################################################
# Copyright 2020, Tryon Solutions, Inc.
# All rights reserved.  Proprietary and confidential.
#
# This file is subject to the license terms found at 
# https://www.cycleautomation.com/end-user-license-agreement/
#
# The methods and techniques described herein are considered
# confidential and/or trade secrets. 
# No part of this file may be copied, modified, propagated,
# or distributed except as authorized by the license.
############################################################ 
# Test Case: BASE-CNT-4021 Mobile Inventory Count Summary Directed.feature
#
# Functional Area: Inventory
# Author: Tryon Solutions
# Blue Yonder WMS Version: Consult Bundle Release Notes
# Test Case Type: Regression
# Blue Yonder Interfaces Interacted With: Mobile, MOCA
#
# Description: This test case performs a cycle summary count on the Mobile App using Directed work mode.
#
# Input Source: Test Case Inputs/BASE-CNT-4021.csv
# Required Inputs:
# 	cnttyp - Count Type. Important to find the next eligible piece of work when we have 
#	  		 multiple count batches for different count types.
#	  		 For this script, it has to be a count type that has the 'Detail Count' setting to On.
# 	blind_counting - blind counting.
#	create_mismatch - create a mismatch count. Only used when no $untqty or $numOUMS are passed in. 
#	  				  In that case it will use those quantities and you can create a mismatch count 
#	  				  by using 'wrong' quantities.
#	untqty_mismatch_increment - amount to increment for mismatch quantity (untqty + untqty_mismatch_increment)
#	cntbat - Count Batch we are working on. Must be a valid count batch with released counts
#	stoloc - Location where the count will take place. Must be a valid location in the system that 
#	  		 has a count in the count batch cntbat.
# Optional Inputs:
# 	prtnum - Item we are going to count. Must be a valid item number for the location and count batch
# 	  		 or invalid if we want to create a count discrepancy. Must be specified in tandem with prt_client_id
# 	prt_client_id - Item Client ID we are going to count. Must be a valid item client id or invalid if
#	  				we want to create a count discrepancy. Must be specified in tandem with prtnum
#	numUOMs - number of UOMs assigned in the part footprint detail number field
#	untqty - qty to count number field
# 
# Assumptions:
# - For Directed work, the user and Mobile App need to be setup to do count work. And there should be no
#   other directed work in the system that the user and device are eligible for. Only count work should show
#   up on the Mobile App.
# - Locations, parts, clients, reason codes are set up for counting
# - The cnttyp specified in is set up for summary counting
# - Some example rows require SERIALIZED CRDL_TO_GRAVE parts to be available in the WMS
# - This test cases does not create inventory to be counted in the dataset, it relies on inventory being in the WMS
# 
# Notes:
# - Test Case Inputs (CSV) - Examples:
#	Exmaple Row: specifying stoloc and specifying a serialized prtnum/prt_client_id with mismatch
#	Example Row: specifying stoloc and specifying prtnum/prt_client_id/untqty/numUOMs
#	Example Row: specifying stoloc, but not prtnum/prt_client_id/untqty/numUOMs
#	Example Row: specifying stoloc and mismatch creation, but not prtnum/prt_client_id/untqty/numUOMs
#	Example Row: specifying stoloc and blind counting, but not prtnum/prt_client_id/untqty/numUOMs
#
############################################################ 
Feature: BASE-CNT-4021 Mobile Inventory Count Summary Directed
 
Background:
############################################################
# Description: Imports dependencies, sets up the environment.
#############################################################

Given I "setup the environment"
	Then I assign all chevron variables to unassigned dollar variables
	And I import scenarios from "Utilities/Base/Environment.feature"
	When I execute scenario "Set Up Environment"

	Given I execute scenario "Mobile Count Imports"
	
	Then I assign "BASE-CNT-4021" to variable "test_case"
	When I execute scenario "Test Data Triggers"

And I "load the dataset"
	Then I assign "Inv_Count_Summary" to variable "dataset_directory"
	And I execute scenario "Perform MOCA Dataset"
 
After Scenario: 
#############################################################
# Description: Logs out of the interface and cleans up the dataset
#############################################################

Given I "perform test completion activities including logging out of the interfaces"
	Then I execute scenario "Test Completion"

And I "cleanup the dataset"
	Then I assign "Inv_Count_Summary" to variable "cleanup_directory"
	And I execute scenario "Perform MOCA Cleanup Script"

@BASE-CNT-4021
Scenario Outline: BASE-CNT-4021 Mobile Inventory Count Summary Directed
CSV Examples: Test Case Inputs/BASE-CNT-4021.csv

Given I "execute pre-test scenario actions (including pre-validations)"
	And I execute scenario "Begin Pre-Test Activities"

Then I "login to the Mobile App"
	Then I execute scenario "Mobile Login"

And I "assign work to the user and navigate to directed work screen"
	Then I execute scenario "Assign Work to User by Count Batch and Count Type"
    And I execute scenario "Mobile Navigate to Directed Work Menu"
    
When I "prcocess the Summary Count"
	Then I execute scenario "Mobile Inventory Count Process Directed Work Screen"
    And I execute scenario "Mobile Inventory Perform Summary Count"
    And I execute scenario "Mobile Exit Directed Work Mode"

Then I "execute post-test scenario actions (including post-validations)"
	And I execute scenario "End Post-Test Activities"