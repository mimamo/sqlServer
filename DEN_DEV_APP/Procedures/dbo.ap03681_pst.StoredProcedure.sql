USE [DEN_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ap03681_pst]    Script Date: 12/21/2015 14:05:55 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.ap03681_pst    Script Date: 4/7/98 12:54:32 PM ******/
CREATE PROC [dbo].[ap03681_pst] @RI_ID smallint            AS
        DELETE FROM ap03681_wrk WHERE RI_ID = @RI_ID
GO
