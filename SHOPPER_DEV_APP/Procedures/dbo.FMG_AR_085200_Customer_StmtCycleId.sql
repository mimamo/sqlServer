USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[FMG_AR_085200_Customer_StmtCycleId]    Script Date: 12/16/2015 15:55:22 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROC [dbo].[FMG_AR_085200_Customer_StmtCycleId] @StmtCycleID VARCHAR (2), @DocType VARCHAR ( 2),
   @DueDate SMALLDATETIME  AS

    SELECT *
      FROM Customer
     WHERE StmtCycleId = @StmtCycleID AND custid IN
          ( SELECT DISTINCT custid
              FROM ARDoc (nolock)
             WHERE ARDoc.DocType IN ('IN', 'DM', @DocType)
             	   AND ARDoc.DueDate <= @DueDate
                   AND ARDoc.curyDocBal > 0
          )
    ORDER BY StmtCycleId, CustId
GO
