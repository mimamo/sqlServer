USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[TaxGroup_TaxID]    Script Date: 12/16/2015 15:55:35 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.TaxGroup_TaxID    Script Date: 4/7/98 12:42:26 PM ******/
Create Proc [dbo].[TaxGroup_TaxID] @parm1 varchar ( 10) AS
        Select * from SlsTaxGrp
            where TaxId = @parm1
            Order by TaxId, GroupId
GO
