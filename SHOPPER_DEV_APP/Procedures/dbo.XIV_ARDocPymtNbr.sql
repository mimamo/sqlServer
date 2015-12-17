USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[XIV_ARDocPymtNbr]    Script Date: 12/16/2015 15:55:38 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Procedure [dbo].[XIV_ARDocPymtNbr] @parm1 smallint, @parm2 VarChar(10) As 
Select * from ARDoc 
where DocClass = 'P' and Rlsed >= @parm1 and Refnbr like @parm2 
Order by Refnbr
GO
