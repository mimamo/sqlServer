USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[Check_for_Selected_Docs]    Script Date: 12/16/2015 15:55:15 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.Check_for_Selected_Docs    Script Date: 4/7/98 12:19:55 PM ******/
Create Procedure [dbo].[Check_for_Selected_Docs] @parm1 varchar ( 10), @parm2 varchar ( 10), @parm3 varchar (3) as
Select * From APCheckDet
Where BatNbr = @parm1 and
RefNbr =  @parm2 and
DocType = @parm3
GO
