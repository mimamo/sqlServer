USE [MID_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ar08600_pst]    Script Date: 12/21/2015 14:17:32 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.ar08600_pst    Script Date: 4/7/98 12:54:32 PM ******/
--apptable
CREATE PROC [dbo].[ar08600_pst] @RI_ID smallint
AS
        DELETE FROM ar08600_wrk WHERE RI_ID = @RI_ID
GO
