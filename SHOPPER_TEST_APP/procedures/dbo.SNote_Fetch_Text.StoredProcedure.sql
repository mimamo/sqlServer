USE [SHOPPER_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[SNote_Fetch_Text]    Script Date: 12/21/2015 16:07:21 ******/
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
