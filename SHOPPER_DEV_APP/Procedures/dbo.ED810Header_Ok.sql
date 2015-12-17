USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ED810Header_Ok]    Script Date: 12/16/2015 15:55:19 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[ED810Header_Ok] @CpnyId varchar(10), @EDIInvID varchar(10) As
Select * From ED810Header Where CpnyId = @CpnyId And EDIInvId = @EDIInvId And UpdateStatus = 'OK'
GO
