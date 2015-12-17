USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[Deduction_VendId]    Script Date: 12/16/2015 15:55:16 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[Deduction_VendId] @parm1 varchar ( 4), @parm2 varchar( 10) as
       Select * from Deduction, Vendor
           where Deduction.VendId = Vendor.VendId
             and Deduction.VendId <> ''
             and CalYr  = @parm1
             and DedId  LIKE  @parm2
           order by DedId
GO
