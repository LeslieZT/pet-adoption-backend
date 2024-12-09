<p align="center">
    <img src="https://res.cloudinary.com/dyntsz5qv/image/upload/v1733582101/logo_ea20st.png" alt="Happy Paws Logo" height="70">
</p>

<h2 align="center">Backend Repository</h2>

> Developed by  [Leslie Zarate](https://github.com/LeslieZT).

![Express.js](https://img.shields.io/badge/express.js-%23404d59.svg?style=for-the-badge&logo=express&logoColor=%2361DAFB)
![NodeJS](https://img.shields.io/badge/node.js-6DA55F?style=for-the-badge&logo=node.js&logoColor=white)
![TypeScript](https://img.shields.io/badge/typescript-%23007ACC.svg?style=for-the-badge&logo=typescript&logoColor=white)
![Prisma](https://img.shields.io/badge/Prisma-3982CE?style=for-the-badge&logo=Prisma&logoColor=white)
![Supabase](https://img.shields.io/badge/Supabase-3ECF8E?style=for-the-badge&logo=supabase&logoColor=white)

<p align="center">
    <a href="https://exploryq.vercel.app" align="center">
        <img src="https://img.icons8.com/color/32/000000/link.png" alt="Website Link" />
    </a>
    <a href="https://www.figma.com/design/fXW7IPhMuYhg3kaVGTTiwD/App-To-Find-Events?node-id=0-1&m=dev&t=SPPGu7PemDSKcoaJ-1">
        <img src="https://img.icons8.com/color/32/000000/figma.png" alt="Figma Link" />
    </a>
    <a href="https://alexamibco.atlassian.net/jira/software/projects/EVENT/boards/67/timeline?shared=&atlOrigin=eyJpIjoiYzM0NDc1YWU0Y2Q1NGJkMzkzZWJhYjM4NDdjNWFlNzUiLCJwIjoiaiJ9">
        <img src="https://img.icons8.com/color/32/000000/jira.png" alt="Jira Link" />
    </a>
    <a href="https://github.com/SebastianUrdaneguiBisalaya/App-To-Find-Events">
        <img src="https://img.icons8.com/color/32/000000/react-native.png" alt="Frontend Respository Link" />
    </a>
</p>

<div>
    <h2>Documentation</h2>
</div>

### Table of Contents
- [Table of Contents](#table-of-contents)
- [About](#about)
- [Database](#database)
- [Endpoints](#endpoints)
  - [Authentication](#authentication)
  - [Pet](#pet)   
  - [Donation](#donation)
  - [Users](#users)
  - [Storage Manager](#storage-manager)
 
### About
Welcome to the **Happy Paws API**, the backend powering the Happy Paws platform, where shelters and pet lovers connect to facilitate pet adoptions.


### Database

![Entity Relationship Diagram](https://res.cloudinary.com/dyntsz5qv/image/upload/v1733716592/db_zshsdi.png)

### Endpoints

#### Authentication

##### Sign Up (POST)
```curl
https://happypaws-api.up.railway.app/api/v1/authentication/sign-up
```

##### Login (POST)

```curl
https://happypaws-api.up.railway.app/api/v1/authentication/sig-in
```
##### Login with OAuth (POST)

```curl
https://happypaws-api.up.railway.app/api/v1/authentication/sign-in/providers
```
##### Login with OAuth Callback (POST)

```curl
https://happypaws-api.up.railway.app/api/v1/authentication/sign-in/providers/:provider/callback
```

##### Log Out (POST)

```curl
https://happypaws-api.up.railway.app/api/v1/authentication/sign-out
```

#### Pet

##### Create Pet (POST)

```curl
https://happypaws-api.up.railway.app/api/v1/pets
```

##### Get Favorite Pets (POST)

```curl
https://happypaws-api.up.railway.app/api/v1/pets/favorite
```

##### Get Pet (POST)

```curl
https://happypaws-api.up.railway.app/api/v1/pets/find-one
```

##### Get Pet Breeds (POST)

```curl
https://happypaws-api.up.railway.app/api/v1/pets/breeds
```

##### Get Pet Categories (POST)

```curl
https://happypaws-api.up.railway.app/api/v1/pets/categories
```

#### Donation

##### Checkout (POST)

```curl
https://happypaws-api.up.railway.app/api/v1/donation/checkout
```

##### Success (GET)

```curl
https://happypaws-api.up.railway.app/api/v1/donation/success
```

##### Cancel (GET)

```curl
https://happypaws-api.up.railway.app/api/v1/donation/cancel
```

#### Users

##### Get User Profile (GET)
```curl
https://happypaws-api.up.railway.app/api/v1/users/profile
```

##### Update User By Id (PUT)

```curl
https://happypaws-api.up.railway.app/api/v1/users/profile
```


#### Storage Manager

###### Upload Image (POST)

```curl
https://happypaws-api.up.railway.app/api/v1/storage/upload
```