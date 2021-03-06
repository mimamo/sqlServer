USE [DAL_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[WOPJPTDSum_Acct_Task]    Script Date: 12/21/2015 13:35:58 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[WOPJPTDSum_Acct_Task]
   @Project    varchar( 16 ),
   @Task       varchar( 32 ),
   @Acct       varchar( 16 )

AS
   SELECT      *
   FROM     	PJPTDSum
   WHERE    	Project = @Project and
         		PJT_Entity = @Task and
         		Acct = @Acct
   ORDER BY    Project, PJT_Entity, Acct
GO
