USE [DEN_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[ARDoc_Cust_Ref_Type]    Script Date: 12/21/2015 15:36:48 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.ARDoc_Cust_Ref_Type    Script Date: 4/7/98 12:30:33 PM ******/
Create proc [dbo].[ARDoc_Cust_Ref_Type] @parm1 varchar ( 6) As
Select * from Ardoc where
        ardoc.docbal = 0 and
        ardoc.rlsed = 1 and
        ardoc.perclosed <= @parm1 and
        ardoc.perclosed <> ''
        order by CustID, Doctype, RefNbr
GO
