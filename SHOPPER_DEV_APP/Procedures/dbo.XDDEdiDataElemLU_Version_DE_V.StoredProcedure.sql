USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[XDDEdiDataElemLU_Version_DE_V]    Script Date: 12/21/2015 14:34:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[XDDEdiDataElemLU_Version_DE_V] @parm1 varchar(6), @parm2 varchar(20), @parm3 smallint AS
  Select * from XDDEdiDataElemLU where EdiVersion = @parm1 and
  SolValue = @parm2 and
  DataElemRN = @parm3
  ORDER by EdiVersion, DataElemRN, SolValue
GO
