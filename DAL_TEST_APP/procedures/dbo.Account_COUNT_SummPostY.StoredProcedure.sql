USE [DAL_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[Account_COUNT_SummPostY]    Script Date: 12/21/2015 13:56:49 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.Account_COUNT_SummPostY    Script Date: 4/7/98 12:38:58 PM ******/
Create Proc [dbo].[Account_COUNT_SummPostY] as
       Select count(Acct) from Account
           where SummPost = 'Y'
GO
