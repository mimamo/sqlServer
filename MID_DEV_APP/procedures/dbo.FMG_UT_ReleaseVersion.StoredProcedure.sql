USE [MID_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[FMG_UT_ReleaseVersion]    Script Date: 12/21/2015 14:17:44 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[FMG_UT_ReleaseVersion] AS

--
-- Show the version of AR Release by scanning syscomments.
--
SELECT CASE WHEN (CHARINDEX("Step 100", text) > 0) THEN
               SUBSTRING(text, (CHARINDEX("Step 100:", text)), (CHARINDEX("Step 100:", text) + 40))
            ELSE
               ''
            END RevInfo
FROM syscomments
WHERE (id = object_id('pp_08400') AND CHARINDEX("Step 100:", text) > 0)

--
-- Show the version of AP Release by scanning syscomments.
--
SELECT CASE WHEN (CHARINDEX("Step 100", text) > 0) THEN
               SUBSTRING(text, (CHARINDEX("Step 100:", text)), (CHARINDEX("Step 100:", text) + 40))
            ELSE
               ''
            END RevInfo
FROM syscomments
WHERE (id = object_id('pp_03400') AND CHARINDEX("Step 100:", text) > 0)
GO
