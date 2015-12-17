USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ED850LineItem_Count]    Script Date: 12/16/2015 15:55:19 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[ED850LineItem_Count] @CpnyId varchar(10), @EDIPOID varchar(10) As
Select Count(*) From ED850LineItem Where CpnyId = @CpnyId And EDIPOID = @EDIPOID
GO
