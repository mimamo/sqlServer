USE [SHOPPER_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDContainer_AddToTare]    Script Date: 12/21/2015 16:07:04 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Procedure [dbo].[EDContainer_AddToTare] @CpnyId varchar(10), @ShipperId varchar(15), @TareId varchar(10) As
Update EDContainer Set TareId = @TareId Where CpnyId = @CpnyId And ShipperId = @ShipperId And
TareFlag = 0 And LTrim(TareId) = ''
GO
