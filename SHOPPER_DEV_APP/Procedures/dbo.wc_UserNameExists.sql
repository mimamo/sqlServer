USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[wc_UserNameExists]    Script Date: 12/16/2015 15:55:36 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE Procedure [dbo].[wc_UserNameExists](
    @UserName   varchar(60) -- A Web Order user name.
)As
    IF EXISTS ( SELECT UserName FROM WCUser WHERE UserName = @UserName )
        SELECT RESULT = CAST(1 AS INT)
    ELSE
        SELECT RESULT = CAST(0 AS INT)
GO
