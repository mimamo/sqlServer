USE [DEN_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[ED_NextToProcess]    Script Date: 12/21/2015 15:36:53 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[ED_NextToProcess] @NextFunctionID varchar(8), @NextClassID varchar(4) AS
Select CpnyId, ShipperId from soshipheader
where NextFunctionID = @NextFunctionID and NextFunctionClass = @NextClassID And Cancelled = 0
order by shipperid
GO
