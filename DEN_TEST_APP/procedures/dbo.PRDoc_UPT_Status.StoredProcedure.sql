USE [DEN_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[PRDoc_UPT_Status]    Script Date: 12/21/2015 15:37:05 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc  [dbo].[PRDoc_UPT_Status] as
       Update PRDoc
           set status = "C"
                   where doctype = "CK"
                   and status = "O"
GO
