USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[SNote_Fetch_Text]    Script Date: 12/16/2015 15:55:35 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.SNote_Fetch_Text    Script Date: 4/17/98 12:50:25 PM ******/
CREATE PROC [dbo].[SNote_Fetch_Text] @parm1 int as
    Select nID, sNoteText from SNote
        where nID = @parm1
        order by nID
GO
