USE [NEWYORKAPP]
GO
/****** Object:  StoredProcedure [dbo].[ED810Header_Ok]    Script Date: 12/21/2015 16:00:57 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[ED810Header_Ok] @CpnyId varchar(10), @EDIInvID varchar(10) As
Select * From ED810Header Where CpnyId = @CpnyId And EDIInvId = @EDIInvId And UpdateStatus = 'OK'
GO
