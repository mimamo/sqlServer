USE [DAL_TEST_APP]
GO
/****** Object:  View [dbo].[xmvad00]    Script Date: 12/21/2015 13:56:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
------------------------------------------------------------------------------------------------------------------------
-- MAG 8/2/11                                                                                              --
-- Created view from SQL originally written by David Martin to extract vendor adds/deletes)                --
--                                                                                                         --
------------------------------------------------------------------------------------------------------------------------

CREATE view [dbo].[xmvad00]
as

SELECT		Vendor_ID   = RTRIM(LTRIM(A.VendId)),
			Vendor_Name = RTRIM(LTRIM(A.Name)),
			Event       = CASE A.AProcess
				            WHEN 'I' THEN 'New'
				            WHEN 'D' THEN 'Delete'
			              END,
			Change_Date = A.ADate,
			Change_Time = SUBSTRING(CONVERT(VARCHAR,A.ADate, 120), 12,5),
			DSL_User    = RTRIM(LTRIM(A.ASolomonUserID))
FROM		xAVendor A
WHERE		AProcess <> 'U'
GO
