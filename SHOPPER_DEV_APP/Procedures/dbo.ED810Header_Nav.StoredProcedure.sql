USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ED810Header_Nav]    Script Date: 12/21/2015 14:34:17 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE Proc [dbo].[ED810Header_Nav] @CpnyId varchar(10), @EDIInvID varchar(10) As
Select * From ED810Header Where CpnyId Like @CpnyId And EDIInvId Like @EDIInvId Order By CpnyId, EDIInvId
GO
