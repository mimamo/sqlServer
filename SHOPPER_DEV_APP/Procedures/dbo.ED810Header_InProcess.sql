USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ED810Header_InProcess]    Script Date: 12/16/2015 15:55:19 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[ED810Header_InProcess] @CpnyId varchar(10) As
Select EDIInvId From ED810Header Where CpnyId = @CpnyId And UpdateStatus = 'IN'
GO
