---
title: Conference Instance entity attributes
description: Learn the attributes you can use with conference instance entities in the Project Academic Knowledge API.
ms.topic: reference
ms.date: 04/19/2021
---

# Conference Instance Entity

> [!NOTE]
> Following attributes are specific to conference instance entity. (Ty = '4')

Name | Description | Type | Operations
--- | --- | --- | ---
CC | Conference instance total citation count | Int32 | None 
CD.D | Date of conference instance event | Date | Equals, IsBetween
CD.T | Name (or type) of a conference instance event Date, e.g. "StartDate", "SubmissionDeadlineDate" | String | Equals, IsBetween
CIARD | Abstract registration due date of the conference instance | Date | Equals, IsBetween
CIED | End date of the conference instance | Date | Equals, IsBetween
CIFVD | Final version due date of the conference instance | Date | Equals, IsBetween
CIL | Location of the conference instance | String | Equals, StartsWith
CIN | Conference instance normalized name | String | Equals
CINDD | Notification date of the conference instance | Date | Equals, IsBetween
CISD | Start date of the conference instance | Date | Equals, IsBetween
CISDD | Submission due date of the conference instance | Date | Equals, IsBetween
DCN | Conference instance display name | String | None
ECC | Conference instance total estimated citation count | Int32 | None
FN | Conference instance full name | String | None
Id | Entity ID | Int64 | Equals
PC | Conference instance total publication count | Int32 | None
PCS.CN | Parent conference series name of the instance | String | Equals
PCS.CId | Parent conference series ID of the instance | Int64 | Equals
