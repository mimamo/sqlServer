USE [DAL_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[Get_ConfirmShipStep]    Script Date: 12/21/2015 13:57:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[Get_ConfirmShipStep]
	@SOTypeID	varchar(4),
	@CpnyID		varchar(10)
as
    SELECT FunctionClass, FunctionID
      FROM SOStep 
     WHERE SOTypeID = @SOTypeID and CpnyID = @CpnyID AND EventType = 'CSHP'
GO
