USE [MIDWESTAPP]
GO
/****** Object:  StoredProcedure [dbo].[XDDEdiSegmentV_Vendid_EC_V]    Script Date: 12/21/2015 15:55:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[XDDEdiSegmentV_Vendid_EC_V] @parm1 varchar(15), @parm2 varchar(4), @parm3 varchar(6) AS
  Select * from XDDEdiSegmentV where Vendid = @parm1 and
  EntryClass = @parm2 and
  EdiVersion = @parm3
  ORDER by Section, SeqNbr
GO
