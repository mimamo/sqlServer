USE [DAL_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[pb_PRStdRate1]    Script Date: 12/21/2015 13:35:47 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[pb_PRStdRate1]
AS
    Declare @Retval smallint
    select @Retval=0
    if exists (select DedId from Deduction where BaseType = 'S') OR
       exists (select Union_Cd from UnionDeduct where BaseType = 'S')
        select @Retval=1
    select @Retval
GO
