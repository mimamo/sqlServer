USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PIdetail_Count]    Script Date: 12/16/2015 15:55:25 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[PIdetail_Count]
   @Parm1 Varchar(10)
as

Select Count(*)
   from PIDetail
   where PIID = @Parm1
GO
