USE [DAL_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[Vendor1099Purge]    Script Date: 12/21/2015 13:35:58 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.Vendor1099Purge    Script Date: 4/7/98 12:19:55 PM ******/
Create Procedure [dbo].[Vendor1099Purge] @parm1 varchar(15) As
Update AP_Balances Set
CYBox00 = NYBox00,
CYBox01 = NYBox01,
CYBox02 = NYBox02,
CYBox03 = NYBox03,
CYBox04 = NYBox04,
CYBox05 = NYBox05,
CYBox06 = NYBox06,
CYBox07 = NYBox07,
CYBox08 = NYBox08,
CYBox09 = NYBox09,
CYBox10 = NYBox10,
CYBox11 = NYBox11,
CYBox12 = NYBox12,
s4Future03 = s4future05,
s4future04 = s4future06,
CYInterest = NYInterest,
NYBox00 = 0.00,
NYBox01 = 0.00,
NYBox02 = 0.00,
NYBox03 = 0.00,
NYBox04 = 0.00,
NYBox05 = 0.00,
NYBox06 = 0.00,
NYBox07 = 0.00,
NYBox08 = 0.00,
NYBox09 = 0.00,
NYBox10 = 0.00,
NYBox11 = 0.00,
NYBox12 = 0.00,
s4future05 = 0.00,
s4future06 = 0.00,
NYInterest = 0.00
Where VendID = @parm1
GO
