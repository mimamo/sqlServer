USE [DENVERAPP]
GO
/****** Object:  StoredProcedure [dbo].[ARLastRefNbr]    Script Date: 12/21/2015 15:42:43 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.ARLastRefNbr    Script Date: 4/7/98 12:30:33 PM ******/
Create Proc [dbo].[ARLastRefNbr] as
    Select LastRefNbr from ARSetup order by SetupId
GO
