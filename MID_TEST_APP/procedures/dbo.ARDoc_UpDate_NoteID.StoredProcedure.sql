USE [MID_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[ARDoc_UpDate_NoteID]    Script Date: 12/21/2015 15:49:10 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.ARDoc_UpDate_NoteID    Script Date: 4/7/98 12:30:33 PM ******/
Create Procedure [dbo].[ARDoc_UpDate_NoteID]  @parm1 varchar ( 10), @parm2 varchar ( 15), @parm3 varchar ( 2), @parm4 varchar ( 10), @parm5 int as
      Update Ardoc Set NoteID = @parm5
        where  BatNbr = @parm1
                and CustId = @parm2
                and DocType = @parm3
                and RefNbr like @parm4
                and Rlsed = 1
GO
