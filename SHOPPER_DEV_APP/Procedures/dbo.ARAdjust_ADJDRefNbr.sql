USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ARAdjust_ADJDRefNbr]    Script Date: 12/16/2015 15:55:13 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.ARAdjust_ADJDRefNbr    Script Date: 4/7/98 12:49:19 PM ******/
Create proc [dbo].[ARAdjust_ADJDRefNbr] @parm1 varchar ( 10) As
Select * from Aradjust
where Aradjust.AdjBatNbr like @parm1
GO
