USE [DENVERAPP]
GO
/****** Object:  StoredProcedure [dbo].[Inventory_LotSerial]    Script Date: 12/21/2015 15:42:56 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.Inventory_LotSerial    Script Date: 4/17/98 10:58:17 AM ******/
/****** Object:  Stored Procedure dbo.Inventory_LotSerial    Script Date: 4/16/98 7:41:52 PM ******/
Create Proc [dbo].[Inventory_LotSerial] @parm1 varchar ( 30) as
    Select * from Inventory where (lotsertrack = 'SI' or lotsertrack = 'LI') and
    InvtId like @parm1
    order by InvtId
GO
