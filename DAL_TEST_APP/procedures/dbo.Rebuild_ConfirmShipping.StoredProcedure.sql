USE [DAL_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[Rebuild_ConfirmShipping]    Script Date: 12/21/2015 13:57:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[Rebuild_ConfirmShipping] AS
   UPDATE Location Set S4Future06 = 0 
    WHERE S4Future06 <> 0
    
   UPDATE LotSerMst Set S4Future06 = 0 
    WHERE S4Future06 <> 0
GO
