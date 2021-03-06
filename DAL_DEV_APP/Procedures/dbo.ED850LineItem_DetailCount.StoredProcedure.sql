USE [DAL_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ED850LineItem_DetailCount]    Script Date: 12/21/2015 13:35:41 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE Proc [dbo].[ED850LineItem_DetailCount] @CpnyId varchar(10), @EDIPOID varchar(10), @LineId int As
Declare @DescrCount int
Declare @SDQCount int
Declare @DiscCount int
Declare @ServicesCount int
Declare @SchedCount int
Declare @SubLineItemCount int
Select @DescrCount = Count(*) From ED850LDesc Where CpnyId = @CpnyId And EDIPOID = @EDIPOID And LineId = @LineId
Select @SDQCount = Count(*) From ED850SDQ Where CpnyId = @CpnyId And EDIPOID = @EDIPOID And LineId = @LineId
Select @DiscCount = Count(*) From ED850LDisc Where CpnyId = @CpnyId And EDIPOID = @EDIPOID And LineId = @LineId
Select @ServicesCount = Count(*) From ED850LSSS Where CpnyId = @CpnyId And EDIPOID = @EDIPOID And LineId = @LineId
Select @SchedCount = Count(*) From ED850Sched Where CpnyId = @CpnyId And EDIPOID = @EDIPOID And LineId = @LineId
Select @SubLineItemCount = Count(*) From ED850SubLineItem Where CpnyId = @CpnyId And EDIPOID = @EDIPOID And LineId = @LineId
Select @DescrCount, @SDQCount, @DiscCount, @ServicesCount, @SchedCount, @SubLineItemCount
GO
