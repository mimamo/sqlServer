USE [DEN_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[Deduction_VendId]    Script Date: 12/21/2015 15:36:50 ******/
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
