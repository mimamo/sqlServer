USE [DEN_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDContainer_SetBOLNbr]    Script Date: 12/21/2015 15:36:54 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE Procedure [dbo].[EDContainer_SetBOLNbr] @CpnyId varchar (10), @ShipperId varchar(15), @BOLNbr varchar(20) As
Update EDContainer Set BOLNbr = @BOLNbr Where CpnyId = @CpnyId And ShipperId = @ShipperId
GO
