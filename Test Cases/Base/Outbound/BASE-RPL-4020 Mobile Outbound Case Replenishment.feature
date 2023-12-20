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
# Test Case: BASE-RPL-4020 Mobile Outbound Case Replenishment.feature
# 
# Functional Area: Replenishment
# Author: Tryon Solutions
# Blue Yonder WMS Version: Consult Bundle Release Notes
# Test Case Type: Regression
# Blue Yonder Interfaces Interacted With: Mobile, MOCA
#
# Description: This test case performs a case replenishment in the Mobile App
#
# Input Source: Test Case Inputs/BASE-RPL-4020.csv
# Required Inputs:
#	oprcod - Operation code
#	vehtyp - Vehicle type
#	ordnum - The ordnum when creating when creating data
#	ship_id - This will be used as the ship_id when creating data
#	adr_id - This will be used as the adr_id when creating data
#	cstnum - This will be used as the cstnum when creating data
#	carcod - This will be used as the carrier for the shipment when creating data. 
#			 This needs to be a valid carrier configured in the system
#	srvlvl - This will be used as the service level for the shipment when creating pick data
#		 	 This needs to be a valid service level for the carrier configured in the system
#	ordtyp - This will be used as the order type for the order when creating pick data.
#			 This needs to be a valid ordtyp configured in the system
#	prtnum - This will be used as the prtnum for the order.
#			 This needs to be a valid prtnum configured in the system.
#			 There must to be sufficient allocatable and pickable inventory of this item in the warehouse
#	untqty - This will be used as the order qty for the order. This needs to be a valid number
#	invsts_prg - This will be used as the inventory status progression on the order line
#				 This needs to be a valid invsts_prg configured in the system
#	wave_num - This will be used as the wave number for the shipment when creating pick data
#	move_id - This will be used as the move ID assigned to the trailer when creating pick data
#	trlr_id - This will be used as the trailer ID for the trailer when creating pick data
#	dock - This will be used as the dock location for the trailer when creating pick data
#	caslod - This will be used as the load number for the case that will be used for the replenishment
#	cassub - This will be used as the case number for the case that will be used for the replenishment
#	casloc - This will be used as the location for the case that will be used for the replenishment
#	casqty - This will be used as the qty when creating the case to replenish
#	adjrea - This will be used as the adjustment reason when creating the pallet to replen
#	adjact - This will be used as the adjustment activity code when creating the pallet to replen
# Optional Inputs:
# None
#
# Assumptions:
# - Testing using a dataset will generate an emergency replenishment for an order
# - There is not sufficient allocatable/pickable inventory of the item number in the warehouse 
#   and an emergency replen will be created
# - The warehouse is configured to allocate emergency replenishments and create directed work on replenishment pick release
#
# Notes:
# None
############################################################ 
Feature: BASE-RPL-4020 Mobile Outbound Case Replenishment

Background:
############################################################
# Description: Imports dependencies, sets up the environment.
#############################################################

Given I "setup the environment"
	Then I assign all chevron variables to unassigned dollar variables
	And I import scenarios from "Utilities/Base/Environment.feature"
	When I execute scenario "Set Up Environment"

	Given I execute scenario "Mobile Replenishment Imports"

	Then I assign "BASE-RPL-4020" to variable "test_case"
	When I execute scenario "Test Data Triggers"

    If I verify variable "mobile_devcod" is assigned
		Then I assign $mobile_devcod to variable "devcod"
	EndIf

And I "load the dataset"
	Then I assign "Allocate_Case_Replen" to variable "dataset_directory"
	And I execute scenario "Perform MOCA Dataset"

After Scenario:
#############################################################
# Description: Logs out of the interface and cleans up the dataset
#############################################################

Given I "perform test completion activities including logging out of the interfaces"
	Then I execute scenario "Test Completion"

And I "cleanup the dataset"
	Then I assign "Allocate_Case_Replen" to variable "cleanup_directory"
	And I execute scenario "Perform MOCA Cleanup Script"

@BASE-RPL-4020
Scenario Outline: BASE-RPL-4020 Mobile Outbound Case Replenishment
CSV Examples: Test Case Inputs/BASE-RPL-4020.csv

Given I "execute pre-test scenario actions (including pre-validations)"
	And I execute scenario "Begin Pre-Test Activities"

Then I "log into the Mobile App and navigate to the directed work sreen"
	And I execute scenario "Mobile Login"
	And I execute scenario "Assign Work to User by Order and Operation"
	And I execute scenario "Mobile Navigate to Directed Work Menu"

When I execute scenario "Mobile Replenishment"

Then I "execute post-test scenario actions (including post-validations)"
	And I execute scenario "End Post-Test Activities"