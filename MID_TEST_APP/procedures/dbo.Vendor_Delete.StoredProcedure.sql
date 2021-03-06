USE [MID_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[Vendor_Delete]    Script Date: 12/21/2015 15:49:34 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.Vendor_Delete    Script Date: 4/7/98 12:19:55 PM ******/
Create Procedure [dbo].[Vendor_Delete] @parm1 smalldatetime, @parm2 smalldatetime as
Select Vendor.*
From Vendor left outer join AP_Balances on Vendor.Vendid =  AP_Balances.Vendid
Where
isnull(AP_Balances.LastVODate, '') <= @parm1 and
isnull(AP_Balances.LastChkDate, '') <= @parm2 and
isnull(AP_Balances.CurrBal, 0) = 0 and
isnull(AP_Balances.FutureBal, 0) = 0 and
isnull(AP_Balances.CYBox00, 0) = 0 and
isnull(AP_Balances.CYBox01, 0) = 0 and
isnull(AP_Balances.CYBox02, 0) = 0 and
isnull(AP_Balances.CYBox03, 0) = 0 and
isnull(AP_Balances.CYBox04, 0) = 0 and
isnull(AP_Balances.CYBox05, 0) = 0 and
isnull(AP_Balances.CYBox06, 0) = 0 and
isnull(AP_Balances.CYBox07, 0) = 0 and
isnull(AP_Balances.CYBox08, 0) = 0 and
isnull(AP_Balances.CYBox09, 0) = 0 and
isnull(AP_Balances.CYBox10, 0) = 0 and
isnull(AP_Balances.CYBox11, 0) = 0 and
isnull(AP_Balances.CYBox12, 0) = 0 and
isnull(AP_Balances.CYInterest, 0) = 0 and
isnull(AP_Balances.NYBox00, 0) = 0 and
isnull(AP_Balances.NYBox01, 0) = 0 and
isnull(AP_Balances.NYBox02, 0) = 0 and
isnull(AP_Balances.NYBox03, 0) = 0 and
isnull(AP_Balances.NYBox04, 0) = 0 and
isnull(AP_Balances.NYBox05, 0) = 0 and
isnull(AP_Balances.NYBox06, 0) = 0 and
isnull(AP_Balances.NYBox07, 0) = 0 and
isnull(AP_Balances.NYBox08, 0) = 0 and
isnull(AP_Balances.NYBox09, 0) = 0 and
isnull(AP_Balances.NYBox10, 0) = 0 and
isnull(AP_Balances.NYBox11, 0) = 0 and
isnull(AP_Balances.NYBox12, 0) = 0 and
isnull(AP_Balances.NYInterest, 0) = 0 and
isnull(AP_Balances.S4Future03, 0) = 0 and
isnull(AP_Balances.S4Future04, 0) = 0 and
isnull(AP_Balances.S4Future05, 0) = 0 and
isnull(AP_Balances.S4Future06, 0) = 0 and
Not EXISTS (SELECT APDoc.RefNbr From APDoc Where
APDoc.VendId = Vendor.VendId)
GO
