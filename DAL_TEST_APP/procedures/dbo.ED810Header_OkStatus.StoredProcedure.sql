USE [DAL_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[ED810Header_OkStatus]    Script Date: 12/21/2015 13:56:59 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE Proc [dbo].[ED810Header_OkStatus] @CpnyId varchar(10) As
Select * From ED810Header Where CpnyId = @CpnyId And UpdateStatus = 'OK'
GO
