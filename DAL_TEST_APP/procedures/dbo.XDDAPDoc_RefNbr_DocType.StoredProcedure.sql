USE [DAL_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[XDDAPDoc_RefNbr_DocType]    Script Date: 12/21/2015 13:57:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[XDDAPDoc_RefNbr_DocType]
   @RefNbr       varchar(10),
   @DocType      varchar(2)

AS
   Select        * from APDoc where
                 RefNbr = @RefNbr and
                 DocType = @DocType and
                 Rlsed = 1
GO
