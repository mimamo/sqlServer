USE [SHOPPER_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[ARDoc_AdJust_Cust_Ref_Type]    Script Date: 12/21/2015 16:06:56 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.ARDoc_AdJust_Cust_Ref_Type    Script Date: 4/7/98 12:30:32 PM ******/
Create proc [dbo].[ARDoc_AdJust_Cust_Ref_Type] @parm1 varchar ( 15), @parm2 varchar ( 10), @parm3 varchar ( 2) As
Select * from Ardoc where
        ardoc.custid = @parm1 and
        ardoc.refnbr = @parm2 and
        ardoc.doctype = @parm3
GO
