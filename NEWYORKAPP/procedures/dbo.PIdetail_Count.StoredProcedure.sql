USE [NEWYORKAPP]
GO
/****** Object:  StoredProcedure [dbo].[PIdetail_Count]    Script Date: 12/21/2015 16:01:06 ******/
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
