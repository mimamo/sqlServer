USE [DENVERAPP]
GO
/****** Object:  StoredProcedure [dbo].[WOPTDSum_PJAcct]    Script Date: 12/21/2015 15:43:13 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[WOPTDSum_PJAcct]
   @Project    varchar( 16 ),
   @Acct       varchar( 16 ),
   @Task       varchar( 32 )

AS
   SELECT      *
   FROM     	PJPTDSum LEFT JOIN PJAcct
         		ON PJPTDSum.Acct = PJAcct.Acct
   WHERE    	PJPTDSum.Project = @Project and
         		PJPTDSum.Acct LIKE @Acct and
         		PJPTDSum.PJT_Entity LIKE @Task
   ORDER BY    PJPTDSum.Project, PJAcct.Acct_Type DESC, PJAcct.Sort_Num, PJAcct.Acct
GO
