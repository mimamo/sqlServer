USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[smConChgLog_ID]    Script Date: 12/21/2015 13:45:07 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[smConChgLog_ID] @parm1 varchar(10), @parm2beg int, @parm2end int AS
        SELECT *
          FROM smConChgLog
         WHERE ContractID  LIKE @parm1
           AND RecordID between @parm2beg and @parm2end
      ORDER BY ContractID,
               ChangedDate DESC,
               ChangedTime DESC,
               RecordID    DESC
GO
