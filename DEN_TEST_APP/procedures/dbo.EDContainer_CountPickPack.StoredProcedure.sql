USE [DEN_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDContainer_CountPickPack]    Script Date: 12/21/2015 15:36:54 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE Proc [dbo].[EDContainer_CountPickPack] @BOLNbr varchar(20), @CpnyId varchar(10), @ShipperId varchar(15) As
Select Count(*) From EDContainer A Where BOLNbr = @BOLNbr And PackMethod <> 'SC' And ContainerId
Not In (Select ContainerId From EDContainer Where CpnyId = @CpnyId And ShipperId = ShipperId)
GO
