USE [SHOPPERAPP]
GO
/****** Object:  StoredProcedure [dbo].[ED850SDQ_CountDiscTaken]    Script Date: 12/21/2015 16:13:10 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[ED850SDQ_CountDiscTaken] @CpnyId varchar(10), @EDIPOID varchar(10) As
Select Count(*) From ED850SDQ Where CpnyId = @CpnyId And EDIPOID = @EDIPOID And DiscTaken = 1
GO
