USE [NEWYORKAPP]
GO
/****** Object:  StoredProcedure [dbo].[ED810_Purge]    Script Date: 12/21/2015 16:00:57 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[ED810_Purge] @CpnyId varchar(10), @VendId varchar(15), @PODateFrom smalldatetime, @PODateTo smalldatetime As
Select EDIInvId Into #EDIPurge From ED810Header Where CpnyId = @CpnyId And VendId Like @VendId And
PODate >= @PODateFrom And PODate <= @PODateTo And UpdateStatus = 'RC'

Delete From ED810Header Where CpnyId = @CpnyId And EDIInvId In (Select EDIInvId From #EDIPurge)
Delete From ED810LineItem Where CpnyId = @CpnyId And EDIInvId In (Select EDIInvId From #EDIPurge)
Delete From ED810Split Where CpnyId = @CpnyId And EDIInvId In (Select EDIInvId From #EDIPurge)
GO
