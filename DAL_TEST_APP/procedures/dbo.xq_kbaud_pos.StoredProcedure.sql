USE [DAL_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[xq_kbaud_pos]    Script Date: 12/21/2015 13:57:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[xq_kbaud_pos] (@RI_ID int)

as

set nocount on

delete xqAAuditMaster where RI_ID = @RI_ID

set nocount off
GO
