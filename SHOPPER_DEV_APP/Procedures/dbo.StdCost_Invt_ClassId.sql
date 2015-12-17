USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[StdCost_Invt_ClassId]    Script Date: 12/16/2015 15:55:35 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[StdCost_Invt_ClassId]
    @parm1 varchar ( 6)
as
Select * from Inventory
    Where ClassId Like @parm1
    And Valmthd = 'T'
Order by InvtId
GO
