USE [MID_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[Batch_PR_Checks]    Script Date: 12/21/2015 15:49:11 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc  [dbo].[Batch_PR_Checks] as
       Select * from Batch
           where Module      =   'PR'
             and EditScrnNbr IN  ('02040', '02070', '02630')
           order by Module ,
                    BatNbr ,
                    Status
GO
